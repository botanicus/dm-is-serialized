require File.join(File.dirname(__FILE__), '..', "spec_helper")
require "dm-is-serialized"

include DataMapper::Is::Serialized::Filters

class Product
  include DataMapper::Resource
  property :id,   Serial
  property :name, String
end

class OrderItem
  include DataMapper::Resource
  is :serialized
  has 1, :product
  property :id,    Serial
  property :name,  String
  property :count, Integer, :default => 1
  property :used,  Boolean, :default => false
  property :note,  Text
end

describe DataMapper::Is::Serialized do
  def serialize_property(property, filter)
    OrderItem.serialized_properties.clear if OrderItem.serialized_properties
    OrderItem.serialize_property property, filter
  end

  before do
    # Do not save it, it is the reason why all the required
    # properties are saved in cookies - that the record
    # isn't saved yet. In shopping cart for example.
    @item = OrderItem.new
  end

  describe BooleanSerializeFilter do
    before do
      serialize_property :used, BooleanSerializeFilter
    end

    describe "false" do
      it "should serialize false value" do
        @item.used = false
        @item.serialize.should eql("0")
      end

      it "should deserialize false value" do
        item = OrderItem.deserialize("0")
        item.used.should be_false
      end
    end

    describe "true" do
      it "should serialize true value" do
        @item.used = true
        @item.serialize.should eql("1")
      end

      it "should deserialize true value" do
        item = OrderItem.deserialize("1")
        item.used.should be_true
      end
    end
  end

  describe GeneralSerializeFilter do
    describe "integers" do
      before do
        @item.count = 5
        serialize_property :count, GeneralSerializeFilter
      end

      it "should serialize integers" do
        @item.serialize.should eql("5")
      end

      it "should deserialize integers" do
        item = OrderItem.deserialize("5")
        item.count.should eql(5)
      end
    end

    describe "strings" do
      before do
        @item.note = "quickly pls!"
        serialize_property :note, GeneralSerializeFilter
      end

      it "should serialize strings" do
        @item.serialize.should eql("quickly pls!")
      end

      it "should raise exception if string is too long" do
        lambda { @item.serialize.should eql("too much long string") }.should raise_error
      end

      it "should deserialize strings" do
        item = OrderItem.deserialize("quickly pls!")
        item.note.should eql("quickly pls!")
      end
    end
  end

  describe ModelSerializeFilter do
    before do
      @product = Product.create
      @item.product = @product
      serialize_property :product, ModelSerializeFilter
    end

    it "should serialize boolean values" do
      @item.serialize.should eql(@product.id.to_s)
    end

    it "should deserialize boolean values" do
      item = OrderItem.deserialize(@product.id.to_s)
      item.product.should eql(@product)
    end
  end
end

require "minitest/autorun"
require_relative "../lib/catalog_service.rb"

class TestCatalogService < Minitest::Test
  SAMPLE_SKU = 'GR1'
  SAMPLE_NAME = 'Green Tea'
  SAMPLE_PRICE = 3.11

  def setup
    @catalog = CatalogService.load_products
  end

  def test_build_product_from_raw_data
    raw_product = [SAMPLE_SKU, SAMPLE_NAME, String(SAMPLE_PRICE)]
    p = CatalogService.build_product_from_raw_data(raw_product)
    assert_equal p.sku, SAMPLE_SKU
    assert_equal p.name, SAMPLE_NAME
    assert_equal p.price, SAMPLE_PRICE
  end

  def test_load_products
    assert @catalog.length > 0
    @catalog.each do |sku, product|
      assert product.sku.is_a?(String)
      assert product.name.is_a?(String)
      assert product.price.is_a?(Float)
    end
  end
end


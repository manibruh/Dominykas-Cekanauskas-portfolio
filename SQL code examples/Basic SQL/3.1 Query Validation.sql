 SELECT sales_detail.SalesOrderId
          ,sales_detail.OrderQty
          ,sales_detail.UnitPrice
          ,sales_detail.LineTotal
          ,sales_detail.ProductId
          ,sales_detail.SpecialOfferID
          ,spec_offer_product.ModifiedDate
          ,spec_offer.Category
          ,spec_offer.Description

   FROM `tc-da-1.adwentureworks_db.salesorderdetail`  as sales_detail

    left join `tc-da-1.adwentureworks_db.specialofferproduct` as spec_offer_product
    on sales_detail.productId = spec_offer_product.ProductID AND
        sales_detail.SpecialOfferID = spec_offer_product.SpecialOfferID
      -- SpecialOfferProduct table has 2 primary keys, which means it needs to match on two keys and not one
      -- otherwise it would return duplicate rows

    left join `tc-da-1.adwentureworks_db.specialoffer` as spec_offer
    on spec_offer_product.SpecialOfferID = spec_offer.SpecialOfferID
    -- was trying to join SalesOrderDetail with SpecialOffer tables, while having no relationship directly
    -- It would match on the wrong ID and would return wrong Category and Description
    -- corrected to join with SpecialOfferProduct and SpecialOffer instead

    order by LineTotal desc
    LIMIT 100; -- Limited only to 100 rows for better result viewing
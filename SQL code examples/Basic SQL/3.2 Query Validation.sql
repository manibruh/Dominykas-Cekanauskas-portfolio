-- to improve:
-- Let's make all aliases readable and the same in every function
-- We will also fix formating in SELECT function
-- Fixed typos in JOIN functions
SELECT  vendor.VendorId as id,
        vendor_contact.ContactId, 
        vendor_contact.ContactTypeId,
        vendor.Name,
        vendor.CreditRating,
        vendor.ActiveFlag,
        vendor_address.AddressId,
        address.City

FROM `tc-da-1.adwentureworks_db.vendor` as vendor -- Fixed .Vendor to .vendor

left join `tc-da-1.adwentureworks_db.vendorcontact` as vendor_contact
  on vendor.VendorId = vendor_contact.VendorId
left join `tc-da-1.adwentureworks_db.vendoraddress` as vendor_address -- Fixed tc-da1 to tc-da-1
  on vendor.VendorId = vendor_address.VendorId
left join `tc-da-1.adwentureworks_db.address` as address
  on vendor_address.AddressId = address.AddressId
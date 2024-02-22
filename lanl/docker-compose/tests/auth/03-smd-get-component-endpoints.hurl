# Check that fetching ComponentEndpoints without specifying an xname works.
GET http://smd:27779/hsm/v2/Inventory/ComponentEndpoints

# We should not be able to GET to ComponentEndpoints without a JWT.
HTTP 401

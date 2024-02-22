# Check that fetching RedfishEndpoints without specifying an xname works.
GET http://smd:27779/hsm/v2/Inventory/RedfishEndpoints

# We should not be able to GET to RedfishEndpoints without a JWT.
HTTP 401

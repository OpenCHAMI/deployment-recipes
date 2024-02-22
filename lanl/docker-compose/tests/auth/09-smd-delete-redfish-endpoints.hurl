# Try deleting RedfishEndpoint.
DELETE http://smd:27779/hsm/v2/Inventory/RedfishEndpoints/x0c0s1b0

# We should not be able to DELETE to RedfishEndpoints without a JWT.
HTTP 401

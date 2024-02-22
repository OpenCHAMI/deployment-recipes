# Try deleting ComponentEndpoint.
DELETE http://smd:27779/hsm/v2/Inventory/ComponentEndpoints/x0c0s1b0

# We should not be able to DELETE to ComponentEndpoints without a JWT.
HTTP 401

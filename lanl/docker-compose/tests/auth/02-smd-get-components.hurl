# Check that fetching Components without specifying an xname works.
GET http://smd:27779/hsm/v2/State/Components

# We should not be able to GET to Components without a JWT.
HTTP 401

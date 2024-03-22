# BSS/SMD Integration Test Hurl Files

**NOTE:** It should be noticed that several of the NID-related files are
suffixed with '.notest' so that they will not be run. BSS is perfectly capable
of generating a boot script for NIDs, but the current version of SMD does not
support displaying/updating NIDs. Since BSS checks SMD for node existence and
thus cannot via NID because of this lack of support, we do not try to generate a
boot script via NID.

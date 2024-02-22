local claims = {
  email_verified: false
} + std.extVar('claims');

{
  identity: {
    traits: {
      // Allowing unverified email addresses enables account
      // enumeration attacks, especially if the value is used for
      // e.g. verification or as a password login identifier.
      //
      // Therefore we only return the email if it (a) exists and (b) is marked verified
      // by GitLab.
      [if "email" in claims && claims.email_verified then "email" else null]: claims.email,
    },
    verified_addresses: std.prune([
      // Carry over verified status from Social Sign-In provider.
      if 'email' in claims && claims.email_verified then { via: 'email', value: claims.email },
    ]),
  },
}

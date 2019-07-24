using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace Infrastructure.Security
{
    public static class JwtSecurity
    {
        public static SecurityKey GetSecurityKey(string secretKey, string securityPhrase)
        {
            var algorithm = new HMACSHA256();
            algorithm.Key = Encoding.UTF8.GetBytes(secretKey);
            byte[] hash = algorithm.ComputeHash(Encoding.UTF8.GetBytes(securityPhrase));
            return new SymmetricSecurityKey(hash);
        }
    }
}

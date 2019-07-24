using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Infrastructure.Security
{
    public static class CoffeeHasher
    {
        private static HMACSHA512 hmac;

        static CoffeeHasher()
        {
            hmac = new HMACSHA512();
        }

        public static byte[] HashWithSalt(string value, byte[] salt)
        {
            hmac.Key = salt;
            var valueBytes = Encoding.Default.GetBytes(value);
            var hash = hmac.ComputeHash(valueBytes);
            return hash;
        }
    }
}

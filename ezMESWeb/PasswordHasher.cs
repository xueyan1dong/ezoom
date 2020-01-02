using Konscious.Security.Cryptography;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace ezMESWeb
{
    public class PasswordHasher
    {
        // Creates a salt from the inputted username and creation_date
        public static byte[] CreateSalt(string username, string creation_date)
        {
            return Encoding.ASCII.GetBytes(username + creation_date);
        }

        // Generates the password hash using Argon2id
        public static byte[] Generate(string password, byte[] salt)
        {
            var argon2 = new Argon2id(Encoding.ASCII.GetBytes(password))
            {
                Salt = salt,
                DegreeOfParallelism = 4, // Number of cores
                MemorySize = 8192, // Measured in KiB
                Iterations = 10
            };

            var hash = argon2.GetBytes(128);
            return hash;
        }

        // Checks whether the inputted password is valid
        public static bool IsValid(string testPassword, string origDelimHash, byte[] salt)
        {
            var newHash = Generate(testPassword, salt);
            byte[] hash = Convert.FromBase64String(origDelimHash);
            //byte[] hash = Encoding.ASCII.GetBytes(origDelimHash);
            return hash.SequenceEqual(newHash);
        }
    }
}
using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Rules
{
    public static class UserRules
    {
        public static int MinimumLengthPassword => 8;
        public static int MaximumLengthPassword => 48;
        public static int MinimumLengthEmail => 5;
        public static int MaximumLengthEmail => 48;
        public static int MinimumLengthName => 2;
        public static int MaximumLengthName => 32;
    }
}

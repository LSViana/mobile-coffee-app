using System;
using System.Collections.Generic;
using System.Text;

namespace Infrastructure.Exceptions
{
    public class ConflictException : HttpException
    {
        public ConflictException(object content) : base(409, content) { }
    }
}

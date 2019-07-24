using System;
using System.Collections.Generic;
using System.Text;

namespace Infrastructure.Exceptions
{
    public class BadRequestException : HttpException
    {
        public BadRequestException(object content) : base(400, content) { }
    }
}

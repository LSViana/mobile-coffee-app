using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Infrastructure.Exceptions
{
    public abstract class HttpException : Exception
    {
        public HttpException(int statusCode, object content)
        {
            StatusCode = statusCode;
            Content = content;
        }

        public int StatusCode { get; }
        public object Content { get; }
    }
}

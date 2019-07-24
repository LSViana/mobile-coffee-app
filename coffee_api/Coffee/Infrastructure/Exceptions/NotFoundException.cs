using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Infrastructure.Exceptions
{
    public class NotFoundException : HttpException
    {
        public NotFoundException(object content) : base(404, content) { }
    }
}

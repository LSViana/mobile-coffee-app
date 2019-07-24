using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Web.Middlewares;

namespace Web.Configurations
{
    public static class ConfigureHttpExceptionMiddleware
    {
        public static IApplicationBuilder UseHttpExceptionMiddleware(this IApplicationBuilder @this)
        {
            @this.UseMiddleware<HttpExceptionMiddleware>();
            //
            return @this;
        }
    }
}

using Infrastructure.Exceptions;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System;
using System.Threading.Tasks;

namespace Web.Middlewares
{
    public class HttpExceptionMiddleware : IMiddleware
    {
        public async Task InvokeAsync(HttpContext context, RequestDelegate next)
        {
            try
            {
                await next(context);
            }
            catch (Exception exception)
            {
                if (exception is HttpException httpException)
                {
                    if (!context.Response.HasStarted)
                    {
                        await HandleException(httpException, context);
                    }
                    else
                    {
                        // If the response had already started, handle the error here
                    }
                }
                // TODO Add logging for the exception
            }
        }

        private async Task HandleException(HttpException httpException, HttpContext context)
        {
            // Building response
            context.Response.StatusCode = httpException.StatusCode;
            if (httpException.Content is null)
            {
                // If there's no content, there's no body
                return;
            }
            context.Response.ContentType = "application/json";
            string contentAsJson;
            if (httpException.Content is string contentString)
            {
                contentAsJson = JsonConvert.SerializeObject(new ErrorInformation()
                {
                    Message = contentString
                });
            }
            else
            {
                contentAsJson = JsonConvert.SerializeObject(httpException.Content);
            }
            await context.Response.WriteAsync(contentAsJson);
        }
    }
}

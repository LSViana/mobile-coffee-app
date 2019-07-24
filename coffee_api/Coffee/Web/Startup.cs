using Data.Context;
using FluentValidation;
using FluentValidation.AspNetCore;
using Infrastructure.Exceptions;
using Infrastructure.Security;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Linq;
using System.Reflection;
using Web.Configurations;
using Web.Middlewares;

namespace Web
{
    public class Startup
    {
        public Startup(IConfiguration configuration, IHostingEnvironment environment)
        {
            Configuration = configuration;
            Environment = environment;
        }

        public IConfiguration Configuration { get; }
        public IHostingEnvironment Environment { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services
                .AddMvc()
                .AddJsonOptions(options =>
                {
                    options.SerializerSettings.Formatting = Newtonsoft.Json.Formatting.None;
                    options.SerializerSettings.NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore;
                    options.SerializerSettings.ObjectCreationHandling = Newtonsoft.Json.ObjectCreationHandling.Replace;
                    options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
                })
                // The following line must not be used to avoid the standard response from FluentValidation
                //.AddFluentValidation()
                .SetCompatibilityVersion(CompatibilityVersion.Version_2_2);
            if (Environment.IsDevelopment())
            {
                services.AddDbContext<CoffeeDb>(x => x.UseInMemoryDatabase("CoffeeDb"));
            }
            else
            {
                throw new NotImplementedException();
            }
            services.AddHttpContextAccessor();
            services.AddMediatR(Assembly.GetAssembly(typeof(HttpException)));
            services.AddScoped(typeof(IPipelineBehavior<,>), typeof(ActorFetchHandler<,>));
            services.AddScoped(typeof(IPipelineBehavior<,>), typeof(ValidationHandler<,>));
            services.AddSeeder(Environment, Configuration);
            services.AddAuthorizationPolicies();
            services.AddTransient<HttpExceptionMiddleware>();
            // Adding assemblies to validate using FluentValidation
            AssemblyScanner.FindValidatorsInAssembly(Assembly.GetAssembly(typeof(HttpException)))
                .ForEach(result => services.AddScoped(result.InterfaceType, result.ValidatorType));
        }

        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseHsts();
            }
            app.UseHttpExceptionMiddleware();
            app.UseAuthentication();
            app.UseHttpsRedirection();
            app.UseMvc();
        }
    }
}

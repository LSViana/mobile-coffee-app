using Domain.Model;
using Microsoft.AspNetCore.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;

namespace Infrastructure.Security
{
    public class AuthorizationPolicies
    {
        private static AuthorizationOptions options;

        public void ConfigureAuthorizationPolicies(Microsoft.AspNetCore.Authorization.AuthorizationOptions options)
        {
            AuthorizationPolicies.options = options;
            #region Stores
            ReadStores();
            #endregion
        }

        #region Stores
        private static void ReadStores() => RequireClaims<User>();
        #endregion

        #region Infrastructure
        private static void RequireClaims<T1>([CallerMemberName] string callerMethod = null) =>
            options.AddPolicy(callerMethod, builder => RequireOneOfTheGenericTypes(new[] { typeof(T1) }, builder));
        private static void RequireClaims<T1, T2>([CallerMemberName] string callerMethod = null) =>
            options.AddPolicy(callerMethod, builder => RequireOneOfTheGenericTypes(new[] { typeof(T1), typeof(T2) }, builder));
        private static void RequireClaims<T1, T2, T3>([CallerMemberName] string callerMethod = null) =>
            options.AddPolicy(callerMethod, builder => RequireOneOfTheGenericTypes(new[] { typeof(T1), typeof(T2), typeof(T3) }, builder));
        private static void RequireClaims<T1, T2, T3, T4>([CallerMemberName] string callerMethod = null) =>
            options.AddPolicy(callerMethod, builder => RequireOneOfTheGenericTypes(new[] { typeof(T1), typeof(T2), typeof(T3), typeof(T4) }, builder));
        private static void RequireOneOfTheGenericTypes(IEnumerable<Type> types, AuthorizationPolicyBuilder builder)
        {
            builder.RequireAssertion(context =>
            {
                var anyAuthorizationClaim = context.User.Claims.Any(x => types.Any(y => y.Name == x.Type));
                return anyAuthorizationClaim;
            });
        }
        #endregion
    }
}

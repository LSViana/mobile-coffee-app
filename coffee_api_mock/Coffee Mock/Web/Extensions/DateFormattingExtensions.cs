using System;
namespace Web.Extensions
{
    public static class DateFormattingExtensions
    {
        public static string WriteHms(this TimeSpan @this)
            => $"{@this.TotalHours}:{@this.Minutes}:{@this.Seconds}";
    }
}

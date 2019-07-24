namespace Infrastructure.ConfigurationModels
{
    public class JwtConfigurationData
    {
        public string Audience { get; set; }
        public string Issuer { get; set; }
        public string SecretKey { get; set; }
        public string SecurityPhrase { get; set; }
        public int LifetimeDays { get; set; }
    }
}

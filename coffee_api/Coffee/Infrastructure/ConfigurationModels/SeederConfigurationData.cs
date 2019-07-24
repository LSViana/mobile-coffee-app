using System;
using System.Collections.Generic;
using System.Text;

namespace Infrastructure.ConfigurationModels
{
    public class SeederConfigurationData
    {
        public string DefaultPassword { get; set; }
        public Guid DefaultSaltGuid { get; set; }
    }
}

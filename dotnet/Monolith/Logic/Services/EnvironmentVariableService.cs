using System.Diagnostics;
using Microsoft.Extensions.Configuration;
using Monolith.Logic.DTOs;

namespace Monolith.Logic.Services
{
    public class EnvironmentVariableService
    {
        private IConfiguration _configuration;

		public List<ExampleDTO> Examples { get; set; } = new List<ExampleDTO>();


		public EnvironmentVariableService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public string GetConnectionString(string key)
        {
			var myConnectionString = _configuration.GetConnectionString(key);
			// "DefaultConnection", 
			return myConnectionString;
		}

		public string GetEnvironmentVariable(string key)
		{
			var myEnvironmentVariable = _configuration.GetValue(key, "empty");
			// "ASPNETCORE_ENVIRONMENT", "Project", "MyAppSettings:APIURL"
			return myEnvironmentVariable;
		}
    }
}

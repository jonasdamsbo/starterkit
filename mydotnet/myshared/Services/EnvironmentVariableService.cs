using System.Diagnostics;
using Microsoft.Extensions.Configuration;

namespace myshared.Services
{
    public class EnvironmentVariableService
    {
        private IConfiguration _configuration;

        public EnvironmentVariableService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public string GetConnectionString(string key)
        {
			var myConnectionString = _configuration.GetConnectionString(key);
			return myConnectionString;
		}
		public string GetEnvironmentVariable(string key)
		{
			var myEnvironmentVariable = _configuration.GetValue(key, "empty");
			return myEnvironmentVariable;
		}
		public string GetEnvironmentVariable(string key, string defaultValue)
		{
			var myEnvironmentVariable = _configuration.GetValue(key, defaultValue);
			return myEnvironmentVariable;
		}

		public string GetConnStr()
        {
            // retrieve nested App Service app setting
            var myHierarchicalConfig = _configuration["My:Hierarchical:Config:Data"];
            // retrieve App Service connection string
            var myConnString = _configuration.GetConnectionString("DefaultConnection");

            Debug.WriteLine(myConnString);

            return myConnString;
        }
        public string GetEnvVar()
        {
            // retrieve nested App Service app setting
            var myHierarchicalConfig = _configuration["My:Hierarchical:Config:Data"];
            // retrieve App Service connection string
            var myEnvironment = _configuration.GetValue("ASPNETCORE_ENVIRONMENT", "empty");

            Debug.WriteLine(myEnvironment);

            return myEnvironment;
        }
        public string GetProj()
        {
            // retrieve nested App Service app setting
            var myHierarchicalConfig = _configuration["My:Hierarchical:Config:Data"];
            // retrieve App Service connection string
            var myProject = _configuration.GetValue("Project", "empty");

            Debug.WriteLine(myProject);

            return myProject;
        }

        public string GetApiUrl()
        {
            // retrieve nested App Service app setting
            var myHierarchicalConfig = _configuration["My:Hierarchical:Config:Data"];
            // retrieve App Service connection string
            var myApiurl = _configuration.GetValue("MyAppSettings:APIURL", "empty");

            Debug.WriteLine(myApiurl);

            return myApiurl;
        }
    }
}

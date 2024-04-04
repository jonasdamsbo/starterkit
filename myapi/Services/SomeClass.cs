using System.Diagnostics;

namespace myapi.Services
{
	public class SomeClass
    {
        private IConfiguration _configuration;

        public SomeClass(IConfiguration configuration)
        {
            _configuration = configuration;
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

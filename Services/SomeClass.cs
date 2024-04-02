using System.Diagnostics;

namespace myblazor.Services
{
	public class SomeClass
    {
        private IConfiguration _configuration;

        public SomeClass(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public string SomeMethod()
        {
            // retrieve nested App Service app setting
            var myHierarchicalConfig = _configuration["My:Hierarchical:Config:Data"];
            // retrieve App Service connection string
            var myConnString = _configuration.GetConnectionString("DefaultConnection");
            Debug.WriteLine(myConnString);
            return myConnString;
        }
    }
}

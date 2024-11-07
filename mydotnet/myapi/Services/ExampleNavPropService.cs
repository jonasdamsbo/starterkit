using Microsoft.EntityFrameworkCore;
using myshared.Models;
using myapi.Data;
using MongoDB.Bson;

namespace myapi.Services
{
	public class ExampleNavPropService
	{
		private MssqlDataContext _dbcontext;
        private DbSet<ExampleNavigationProperty> _exampleNavigationPropertyRepository;
		private ILogger<ExampleNavPropService> _log;

		public ExampleNavPropService(
			ILogger<ExampleNavPropService> log,
			MssqlDataContext dbcontext
		)
		{
			_dbcontext = dbcontext;
			_exampleNavigationPropertyRepository = dbcontext.ExampleNavigationProperties;
			_log = log;
		}

		public async Task<List<ExampleNavigationProperty>> GetAllAsync()
		{
            var exampleNavigationProperties = new List<ExampleNavigationProperty>();

            try
            {
                exampleNavigationProperties = await _exampleNavigationPropertyRepository.ToListAsync();
            }
            catch (Exception ex)
            {
                _log.LogError("### EXCEPTION WAS CAUGHT IN EXAMPLENAVPROPSERVICE GETALLASYNC WITH MESSAGE: " + ex + " ###");
            }


            if (exampleNavigationProperties == new List<ExampleNavigationProperty>()) return new List<ExampleNavigationProperty>();
			if (exampleNavigationProperties is null) return null;
			
			return exampleNavigationProperties;
		}

		public async Task<ExampleNavigationProperty?> GetByIdAsync(string id)
		{
			var exampleNavigationProperty = await _exampleNavigationPropertyRepository.Include(x => x.ExampleModel).Where(x => x.Id == id).FirstOrDefaultAsync();

			if (exampleNavigationProperty == new ExampleNavigationProperty()) return new ExampleNavigationProperty();
			if (exampleNavigationProperty is null) return null;

			return exampleNavigationProperty;
		}

		public async Task<ExampleNavigationProperty?> GetAllRelatedToExampleModelIdAsync(string exampleModelId)
		{
			var exampleNavigationProperty = await _exampleNavigationPropertyRepository.Include(x => x.ExampleModel).Where(x => x.ExampleModel.Id == exampleModelId).FirstOrDefaultAsync();

			if (exampleNavigationProperty == new ExampleNavigationProperty()) return new ExampleNavigationProperty();
			if (exampleNavigationProperty is null) return null;

			return exampleNavigationProperty;
		}

		public async Task<ExampleNavigationProperty> AddAsync(ExampleNavigationProperty exampleNavProp)
		{
			if (exampleNavProp != null)
			{
				exampleNavProp.Id = ObjectId.GenerateNewId().ToString();
				await _exampleNavigationPropertyRepository.AddAsync(exampleNavProp);
				await _dbcontext.SaveChangesAsync();

				exampleNavProp = await _exampleNavigationPropertyRepository.Where(x => x.Id == exampleNavProp.Id).FirstOrDefaultAsync();
			}

			if (exampleNavProp == new ExampleNavigationProperty()) return new ExampleNavigationProperty();
			if (exampleNavProp is null) return null;

			return exampleNavProp;
		}

		public async Task<ExampleNavigationProperty?> UpdateAsync(string id, ExampleNavigationProperty updatedNavProp)
		{
			var exampleNavProp = await _exampleNavigationPropertyRepository.Where(x => x.Id == id).FirstOrDefaultAsync();
			if (exampleNavProp != null)
			{
				exampleNavProp.Title = updatedNavProp.Title;

				await _dbcontext.SaveChangesAsync();

				exampleNavProp = await _exampleNavigationPropertyRepository.Where(x => x.Id == id).FirstOrDefaultAsync();
			}

			if (exampleNavProp == new ExampleNavigationProperty()) return new ExampleNavigationProperty();
			if (exampleNavProp is null) return null;

			return exampleNavProp;
		}

		public async Task<ExampleNavigationProperty?> DeleteAsync(string id)
		{
			var exampleNavProp = await _exampleNavigationPropertyRepository.Where(x => x.Id == id).FirstOrDefaultAsync();
			if (exampleNavProp != null)
			{
				_exampleNavigationPropertyRepository.Remove(exampleNavProp);
				await _dbcontext.SaveChangesAsync();
			}

			if (exampleNavProp is null) return new ExampleNavigationProperty();

			return exampleNavProp;
		}
	}
}

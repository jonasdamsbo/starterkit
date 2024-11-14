using Microsoft.EntityFrameworkCore;
using myshared.Models;
using MongoDB.Bson;
using myapi.Repositories;
using Microsoft.IdentityModel.Tokens;
using Microsoft.TeamFoundation.Common;

namespace myapi.Services
{
	public class ExampleNavigationPropertyService
	{
		private ExampleNavigationPropertyRepository _exampleNavigationPropertyRepository;
		private ILogger<ExampleNavigationPropertyService> _log;

		public ExampleNavigationPropertyService(
			ILogger<ExampleNavigationPropertyService> log,
			ExampleNavigationPropertyRepository exampleNavigationPropertyRepository
		)
		{
			_exampleNavigationPropertyRepository = exampleNavigationPropertyRepository;
			_log = log;
		}

		public async Task<List<ExampleNavigationProperty>?> GetAllAsync()
		{
            var exampleNavigationProperties = await _exampleNavigationPropertyRepository.GetAllAsync();

			if (exampleNavigationProperties is null) return null;
            if (exampleNavigationProperties.Count() < 1) return new List<ExampleNavigationProperty>();

			return exampleNavigationProperties;
		}

		public async Task<ExampleNavigationProperty?> GetByIdAsync(string id)
		{
			var exampleNavigationProperty = await _exampleNavigationPropertyRepository.GetByIdAsync(id);
			
			if (exampleNavigationProperty is null) return null;
			if (exampleNavigationProperty.Id.IsNullOrEmpty()) return new ExampleNavigationProperty();

			return exampleNavigationProperty;
		}

		public async Task<List<ExampleNavigationProperty>?> GetAllRelatedToExampleModelIdAsync(string exampleModelId)
		{
			var exampleNavigationProperties = await _exampleNavigationPropertyRepository.GetAllRelatedToIdAsync(exampleModelId);

			if (exampleNavigationProperties is null) return null;
            if (exampleNavigationProperties.Count() < 1) return new List<ExampleNavigationProperty>();

			return exampleNavigationProperties;
		}

		public async Task<ExampleNavigationProperty?> AddAsync(ExampleNavigationProperty exampleNavProp)
		{
			exampleNavProp.Id = ObjectId.GenerateNewId().ToString();
			var newExampleNavProp = await _exampleNavigationPropertyRepository.AddAsync(exampleNavProp);

			if (newExampleNavProp is null) return null;
			if (newExampleNavProp.Id.IsNullOrEmpty()) return new ExampleNavigationProperty();

			return newExampleNavProp;
		}

		public async Task<ExampleNavigationProperty?> UpdateAsync(string id, ExampleNavigationProperty updatedNavProp)
		{
			var updatedModel = await _exampleNavigationPropertyRepository.UpdateAsync(id, updatedNavProp);

			if (updatedModel is null) return null;
			if (updatedModel.Id.IsNullOrEmpty()) return new ExampleNavigationProperty();

			return updatedModel;
		}

		public async Task<ExampleNavigationProperty?> DeleteAsync(string id)
		{
			var exampleModel = await _exampleNavigationPropertyRepository.DeleteAsync(id);

			if (exampleModel is null) return null;
			if (exampleModel.Id.IsNullOrEmpty()) return new ExampleNavigationProperty();

			return exampleModel;
		}
	}
}

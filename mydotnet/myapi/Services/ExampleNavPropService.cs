using Microsoft.IdentityModel.Tokens;
using myapi.Repositories;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Services
{
	public class ExampleNavPropService
	{
		private ExampleModelRepository _exampleModelRepository;
		private ExampleNavigationPropertyRepository _exampleNavigationPropertyRepository;

		public ExampleNavPropService(
			ExampleModelRepository exampleModelRepository, 
			ExampleNavigationPropertyRepository exampleNavigationPropertyRepository
		)
		{
			_exampleModelRepository = exampleModelRepository;
			_exampleNavigationPropertyRepository = exampleNavigationPropertyRepository;
		}

		public async Task<List<ExampleNavigationProperty>> GetAllAsync()
		{
			var exampleModels = await _exampleNavigationPropertyRepository.GetAllAsync();

			if (exampleModels == new List<ExampleNavigationProperty>()) return new List<ExampleNavigationProperty>();
			if (exampleModels is null) return null;

			return exampleModels;
		}

		public async Task<ExampleNavigationProperty?> GetByIdAsync(string id)
		{
			var exampleNavigationProperty = await _exampleNavigationPropertyRepository.GetByIdAsync(id);

			if (exampleNavigationProperty == new ExampleNavigationProperty()) return new ExampleNavigationProperty();
			if (exampleNavigationProperty is null) return null;

			return exampleNavigationProperty;
		}

		public async Task<ExampleNavigationProperty> AddAsync(ExampleNavigationProperty exampleNavProp)
		{
			var exampleNavPropResult = await _exampleNavigationPropertyRepository.AddAsync(exampleNavProp);

			if (exampleNavPropResult == new ExampleNavigationProperty()) return new ExampleNavigationProperty();
			if (exampleNavPropResult is null) return null;

			return exampleNavPropResult;
		}

		public async Task<ExampleNavigationProperty?> UpdateAsync(string id, ExampleNavigationProperty updatedNavProp)
		{
			await _exampleNavigationPropertyRepository.UpdateAsync(id, updatedNavProp);

			if (updatedNavProp == new ExampleNavigationProperty()) return new ExampleNavigationProperty();
			if (updatedNavProp is null) return null;

			return updatedNavProp;
		}

		public async Task<ExampleNavigationProperty?> DeleteAsync(string id)
		{
			var exampleNavProp = await _exampleNavigationPropertyRepository.DeleteAsync(id);

			if (exampleNavProp == new ExampleNavigationProperty()) return new ExampleNavigationProperty();
			if (exampleNavProp is null) return null;

			return exampleNavProp;
		}
	}
}

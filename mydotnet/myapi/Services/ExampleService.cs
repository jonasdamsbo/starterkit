using Microsoft.IdentityModel.Tokens;
using myapi.Repositories;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Services
{
	public class ExampleService
	{
		private ExampleModelRepository _exampleModelRepository;
		private ExampleNavigationPropertyRepository _exampleNavigationPropertyRepository;
		//private bool sql = true;

		public ExampleService(
			ExampleModelRepository exampleModelRepository, 
			ExampleNavigationPropertyRepository exampleNavigationPropertyRepository
		)
		{
			_exampleModelRepository = exampleModelRepository;
			_exampleNavigationPropertyRepository = exampleNavigationPropertyRepository;
		}

		public async Task<List<ExampleDTO>> GetAllAsync()
		{
			var exampleModels = await _exampleModelRepository.GetAllAsync(); 
			if(exampleModels.First().ExampleNavigationProperty.IsNullOrEmpty()) exampleModels.ForEach(x => x.ExampleNavigationProperty = _exampleNavigationPropertyRepository.GetAllRelatedToIdAsync(x.Id).GetAwaiter().GetResult()); // required for mssql
			//if (sql) exampleModels.ForEach(async x => x.ExampleNavigationProperty = await _exampleNavigationPropertyRepository.GetAllRelatedToIdAsync(x.Id)); // required for mssql


			if (exampleModels == new List<ExampleModel>()) return new List<ExampleDTO>();
			if (exampleModels is null) return null;

			var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x)).ToList();
			return exampleDTOs;
		}

		public async Task<ExampleDTO?> GetByIdAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.GetByIdAsync(id);
			if (exampleModel.ExampleNavigationProperty.IsNullOrEmpty()) exampleModel.ExampleNavigationProperty = await _exampleNavigationPropertyRepository.GetAllRelatedToIdAsync(exampleModel.Id); // required for mssql
			//if (sql) exampleModel.ExampleNavigationProperty = await _exampleNavigationPropertyRepository.GetAllRelatedToIdAsync(exampleModel.Id); // required for mssql

			if (exampleModel == new ExampleModel()) return new ExampleDTO();
			if (exampleModel is null) return null;

			return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO> AddAsync(ExampleDTO exampleDTO)
		{
			var exampleModel = new ExampleModel(exampleDTO);

			exampleModel = await _exampleModelRepository.AddAsync(exampleModel);

			if (exampleModel == new ExampleModel()) return new ExampleDTO();
			if (exampleModel is null) return null;

			return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO?> UpdateAsync(string id, ExampleDTO updatedExampleDTO)
		{
			var updatedExampleModel = new ExampleModel(updatedExampleDTO);
			updatedExampleModel = await _exampleModelRepository.UpdateAsync(id, updatedExampleModel);

			if (updatedExampleModel == new ExampleModel()) return new ExampleDTO();
			if (updatedExampleModel is null) return null;

			return new ExampleDTO(updatedExampleModel);
		}

		public async Task<ExampleDTO?> DeleteAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.DeleteAsync(id);

			if (exampleModel == new ExampleModel()) return new ExampleDTO();
			if (exampleModel is null) return null;

			return new ExampleDTO(exampleModel);
		}
	}
}

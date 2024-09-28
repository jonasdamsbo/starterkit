using Microsoft.IdentityModel.Tokens;
using myapi.Repositories;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Services
{
	public class ExampleService
	{
		private ExampleModelRepository _exampleModelRepository;

		public ExampleService(ExampleModelRepository exampleModelRepository)
		{
			_exampleModelRepository = exampleModelRepository;
		}

		public async Task<List<ExampleDTO>> GetAllAsync()
		{
			var exampleModels = await _exampleModelRepository.GetAllAsync();

			if (exampleModels.IsNullOrEmpty()) return new List<ExampleDTO>();
			
			var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x)).ToList();
			return exampleDTOs;
		}

		public async Task<ExampleDTO?> GetByIdAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.GetByIdAsync(id);

			if(exampleModel == null) return null;

			return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO> AddAsync(ExampleDTO exampleDTO)
		{
			var exampleModel = new ExampleModel(exampleDTO);

			exampleModel = await _exampleModelRepository.AddAsync(exampleModel);

			if(exampleModel == null) return null;
			return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO?> UpdateAsync(string id, ExampleDTO updatedExampleDTO)
		{
			var updatedExampleModel = new ExampleModel(updatedExampleDTO);
			updatedExampleModel = await _exampleModelRepository.UpdateAsync(id, updatedExampleModel);

			if(updatedExampleModel == null) return null;
			return new ExampleDTO(updatedExampleModel);
		}

		public async Task<ExampleDTO?> DeleteAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.DeleteAsync(id);

			if(exampleModel == null) return null;
			return new ExampleDTO(exampleModel);
		}
	}
}

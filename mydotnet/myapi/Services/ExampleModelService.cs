using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using myshared.DTOs;
using myshared.Models;
using myapi.Repositories;
using Microsoft.IdentityModel.Tokens;
using Microsoft.TeamFoundation.Common;

namespace myapi.Services
{
	public class ExampleModelService
	{
		private ExampleModelRepository _exampleModelRepository;
		private ILogger<ExampleModelService> _log;

        public ExampleModelService(
			ILogger<ExampleModelService> log,
			ExampleModelRepository exampleModelRepository
		)
		{
			_exampleModelRepository = exampleModelRepository;
			_log = log;
        }

		public async Task<List<ExampleDTO>?> GetAllAsync()
		{
			var exampleModels = await _exampleModelRepository.GetAllAsync();

			if (exampleModels is null) return null;
            if (exampleModels.Count() < 1) return new List<ExampleDTO>();

			var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x)).ToList();
			return exampleDTOs;
		}

		public async Task<ExampleDTO?> GetByIdAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.GetByIdAsync(id);
			
			if (exampleModel is null) return null;
			if (exampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO?> AddAsync(ExampleDTO exampleDTO)
		{
			var exampleModel = new ExampleModel(exampleDTO);

			exampleModel.Id = ObjectId.GenerateNewId().ToString();
			var newExampleModel = await _exampleModelRepository.AddAsync(exampleModel);

			if (newExampleModel is null) return null;
			if (newExampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			return new ExampleDTO(newExampleModel);
		}

		public async Task<ExampleDTO?> UpdateAsync(string id, ExampleDTO updatedExampleDTO)
		{
			var exampleModel = new ExampleModel(updatedExampleDTO);
			var updatedExampleModel = await _exampleModelRepository.UpdateAsync(id, exampleModel);

			if (updatedExampleModel is null) return null;
			if (updatedExampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO?> DeleteAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.DeleteAsync(id);

			if (exampleModel is null) return null;
			if (exampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			return new ExampleDTO(exampleModel);
		}
	}
}

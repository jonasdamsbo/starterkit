using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using Monolith.Logic.DTOs;
using Monolith.Data.Models;
using Monolith.Query.Repositories;
using Microsoft.IdentityModel.Tokens;
using Monolith.Query.Projections;
//using Microsoft.TeamFoundation.Common;

namespace Monolith.Logic.Services
{
	public class ExampleModelService
	{
		private IExampleModelRepository _exampleModelRepository;
		private ILogger<ExampleModelService> _log;
		private DtoMapper _dtoMapper;

        public ExampleModelService(
			ILogger<ExampleModelService> log,
			IExampleModelRepository exampleModelRepository,
			DtoMapper dtoMapper
		)
		{
			_exampleModelRepository = exampleModelRepository;
			_log = log;

			// homemade mapper
			_dtoMapper = dtoMapper;
        }

		public async Task<List<ExampleDTO>?> GetAllAsync()
		{
			// get list of models
			var exampleModels = await _exampleModelRepository.GetAllAsync();

			// check if null or empty
			if (exampleModels is null) return null;
            if (exampleModels.Count() < 1) return new List<ExampleDTO>();

			var exampleModelsDTO = exampleModels.Select(example => _dtoMapper.ToExampleDTO(example)).ToList();

			return exampleModelsDTO;
		}

		public async Task<ExampleDTO?> GetByIdAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.GetByIdAsync(id);
			
			if (exampleModel is null) return null;
			if (exampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			var exampleModelDto = _dtoMapper.ToExampleDTO(exampleModel);
			
			return exampleModelDto;
		}

		public async Task<ExampleDTO?> AddAsync(ExampleDTO exampleDTO)
		{
			exampleDTO.Id = ObjectId.GenerateNewId().ToString();
			exampleDTO.ExampleNavigationProperties = new List<ExampleNavigationPropertyDTO>();
			//var exampleModel = new ExampleProjection(exampleDTO);

			var newExampleModel = await _exampleModelRepository.AddAsync(exampleDTO);

			if (newExampleModel is null) return null;
			if (newExampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			return new ExampleDTO(newExampleModel);
		}

		public async Task<ExampleDTO?> UpdateAsync(string id, ExampleDTO updatedExampleDTO)
		{
			//var exampleModel = new ExampleProjection(updatedExampleDTO);
			//exampleModel.Id = id;
			updatedExampleDTO.Id = id;


			var updatedExampleModel = await _exampleModelRepository.UpdateAsync(id, updatedExampleDTO);

			if (updatedExampleModel is null) return null;
			if (updatedExampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			return new ExampleDTO(updatedExampleModel);
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

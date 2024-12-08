using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using myshared.DTOs;
using myshared.Models;
using myapi.Repositories;
using Microsoft.IdentityModel.Tokens;
using Microsoft.TeamFoundation.Common;
using Mapster;
using AutoMapper;

namespace myapi.Services
{
	public class ExampleModelService
	{
		private IExampleModelRepository _exampleModelRepository;
		private ILogger<ExampleModelService> _log;

		// automapper
		//private readonly IMapper _autoMapper;

        public ExampleModelService(
			ILogger<ExampleModelService> log,
			IExampleModelRepository exampleModelRepository/*,
			IMapper autoMapper*/
		)
		{
			_exampleModelRepository = exampleModelRepository;
			_log = log;

			// automapper
			//_autoMapper = autoMapper;

			// mapster
			//ConfigureMapster();
        }

		public async Task<List<ExampleDTO>?> GetAllAsync()
		{
			var exampleModels = await _exampleModelRepository.GetAllAsync();

			if (exampleModels is null) return null;
            if (exampleModels.Count() < 1) return new List<ExampleDTO>();

			// maps

			// mapster
			var mapsterExample = exampleModels.Select(example => example.Adapt<ExampleDTO>()).ToList();

			//automapper
			//var automapperExample = exampleModels.Select(example => _autoMapper.Map<ExampleDTO>(example)).ToList();

			// manual mapping
			//var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x)).ToList();

			return mapsterExample;
		}

		public async Task<ExampleDTO?> GetByIdAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.GetByIdAsync(id);
			
			if (exampleModel is null) return null;
			if (exampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			//mapster
			return exampleModel.Adapt<ExampleDTO>();
			//manual mapping
			//return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO?> AddAsync(ExampleDTO exampleDTO)
		{
			//manual mapping
			//var exampleModel = new ExampleModel(exampleDTO);
			//mapster
			var exampleModel = exampleDTO.Adapt<ExampleModel>();

			exampleModel.Id = ObjectId.GenerateNewId().ToString();
			var newExampleModel = await _exampleModelRepository.AddAsync(exampleModel);

			if (newExampleModel is null) return null;
			if (newExampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			//manual mapping
			//return new ExampleDTO(newExampleModel);
			//mapster
			return exampleModel.Adapt<ExampleDTO>();
		}

		public async Task<ExampleDTO?> UpdateAsync(string id, ExampleDTO updatedExampleDTO)
		{
			// manual mapping
			//var exampleModel = new ExampleModel(updatedExampleDTO);
			//mapster
			var exampleModel = updatedExampleDTO.Adapt<ExampleModel>();


			var updatedExampleModel = await _exampleModelRepository.UpdateAsync(id, exampleModel);

			if (updatedExampleModel is null) return null;
			if (updatedExampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			// manual mapping
			// return new ExampleDTO(exampleModel);
			//mapster
			return exampleModel.Adapt<ExampleDTO>();
		}

		public async Task<ExampleDTO?> DeleteAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.DeleteAsync(id);

			if (exampleModel is null) return null;
			if (exampleModel.Id.IsNullOrEmpty()) return new ExampleDTO();

			// manual mapping
			//return new ExampleDTO(exampleModel);
			// mapster
			return exampleModel.Adapt<ExampleDTO>();
		}

		// mapster config example
		// if the property names are the same, like model.name and dto.name, the mapper can infer the map automatically and ConfigureMapster() can be removed entirely
		// if the property names you want to map are different, like model.name and dto.fullname, we make a config
		//void ConfigureMapster()
		//{
		//	TypeAdapterConfig<ExampleModel, ExampleDTO>.NewConfig()
		//		.Map(dest => dest.Description, src => src.Description);
		//}

		// automapper profile example
		//class AutoMapperProfile : Profile
		//{
		//	public AutoMapperProfile()
		//	{
		//		CreateMap<ExampleModel, ExampleDTO>().ReverseMap();
		//	}
		//}
	}
}

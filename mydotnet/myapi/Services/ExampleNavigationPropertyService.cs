﻿using Microsoft.EntityFrameworkCore;
using myshared.Models;
using MongoDB.Bson;
using myapi.Repositories;
using Microsoft.IdentityModel.Tokens;
using Microsoft.TeamFoundation.Common;
using myshared.DTOs;

namespace myapi.Services
{
	public class ExampleNavigationPropertyService
	{
		private ExampleNavigationPropertyRepository _exampleNavigationPropertyRepository;
		private ILogger<ExampleNavigationPropertyService> _log;
		private DtoMapper _dtoMapper;

		public ExampleNavigationPropertyService(
			ILogger<ExampleNavigationPropertyService> log,
			ExampleNavigationPropertyRepository exampleNavigationPropertyRepository,
			DtoMapper dtoMapper
		)
		{
			_exampleNavigationPropertyRepository = exampleNavigationPropertyRepository;
			_log = log;
			_dtoMapper = dtoMapper;
		}

		public async Task<List<ExampleNavigationPropertyDTO>?> GetAllAsync()
		{
            var exampleNavigationProperties = await _exampleNavigationPropertyRepository.GetAllAsync();

			if (exampleNavigationProperties is null) return null;
            if (exampleNavigationProperties.Count() < 1) return new List<ExampleNavigationPropertyDTO>();

			var exampleNavigationPropertyDTOs = exampleNavigationProperties.Select(x => _dtoMapper.Map(x, new ExampleNavigationPropertyDTO())).ToList();

			return exampleNavigationPropertyDTOs;
		}

		public async Task<ExampleNavigationPropertyDTO?> GetByIdAsync(string id)
		{
			var exampleNavigationProperty = await _exampleNavigationPropertyRepository.GetByIdAsync(id);
			
			if (exampleNavigationProperty is null) return null;
			if (exampleNavigationProperty.Id.IsNullOrEmpty()) return new ExampleNavigationPropertyDTO();

			var exampleNavigationPropertyDTO = _dtoMapper.Map(exampleNavigationProperty, new ExampleNavigationPropertyDTO());

			return exampleNavigationPropertyDTO;
		}

		public async Task<List<ExampleNavigationPropertyDTO>?> GetByExampleModelIdAsync(string exampleModelId)
		{
			var exampleNavigationProperties = await _exampleNavigationPropertyRepository.GetByExampleModelIdAsync(exampleModelId);

			if (exampleNavigationProperties is null) return null;
            if (exampleNavigationProperties.Count() < 1) return new List<ExampleNavigationPropertyDTO>();

			var exampleNavigationPropertyDTOs = exampleNavigationProperties.Select(x => _dtoMapper.Map(x, new ExampleNavigationPropertyDTO())).ToList();

			return exampleNavigationPropertyDTOs;
		}

		public async Task<ExampleNavigationPropertyDTO?> AddAsync(ExampleNavigationProperty exampleNavProp)
		{
			exampleNavProp.Id = ObjectId.GenerateNewId().ToString();
			var newExampleNavProp = await _exampleNavigationPropertyRepository.AddAsync(exampleNavProp);

			if (newExampleNavProp is null) return null;
			if (newExampleNavProp.Id.IsNullOrEmpty()) return new ExampleNavigationPropertyDTO();

			var newExampleNavPropDTO = _dtoMapper.Map(newExampleNavProp, new ExampleNavigationPropertyDTO());

			return newExampleNavPropDTO;
		}

		public async Task<ExampleNavigationPropertyDTO?> UpdateAsync(string id, ExampleNavigationProperty updatedNavProp)
		{
			var updatedModel = await _exampleNavigationPropertyRepository.UpdateAsync(id, updatedNavProp);

			if (updatedModel is null) return null;
			if (updatedModel.Id.IsNullOrEmpty()) return new ExampleNavigationPropertyDTO();

			var updatedModelDTO = _dtoMapper.Map(updatedModel, new ExampleNavigationPropertyDTO());

			return updatedModelDTO;
		}

		public async Task<ExampleNavigationPropertyDTO?> DeleteAsync(string id)
		{
			var exampleModel = await _exampleNavigationPropertyRepository.DeleteAsync(id);

			if (exampleModel is null) return null;
			if (exampleModel.Id.IsNullOrEmpty()) return new ExampleNavigationPropertyDTO();

			var exampleModelDTO = _dtoMapper.Map(exampleModel, new ExampleNavigationPropertyDTO());

			return exampleModelDTO;
		}
	}
}

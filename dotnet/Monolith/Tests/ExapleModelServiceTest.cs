// xunit, requires nugetpackages: xunit + xunit.runner.visualstudio + Microsoft.NET.Test.Sdk
using Xunit;
using Monolith.Data.Models;
using Monolith.Query.Repositories;
using Moq;
using Monolith.Logic.Services;
using Monolith.Logic.DTOs;

namespace Monolith.Tests
{
	public class ExapleModelServiceTest
	{
		[Fact]
		public async Task GetModelAsync_ValidId_ReturnsDto()
		{
			// Arrange
			var modelId = "1";
			var expectedModel = new ExampleModel
			{
				Id = modelId,
				Title = "test",
				Description = "test",
				//WebUrl = "test",
				ExampleNavigationProperties = null
			};

			var mockRepository = new Mock<IExampleModelRepository>();
			mockRepository
				.Setup(repo => repo.GetByIdAsync(It.Is<string>(id => id == modelId)))
				.ReturnsAsync(expectedModel);

			var mockLog = new Mock<ILogger<ExampleModelService>>();

			var mockDtomapper = new Mock<DtoMapper>();

			var service = new ExampleModelService(mockLog.Object, mockRepository.Object, mockDtomapper.Object);

			// Act
			var result = await service.GetByIdAsync(modelId);

			// Assert
			Assert.NotNull(result);
			Assert.Equal(expectedModel.Id, result.Id);
			Assert.Equal(expectedModel.Title, result.Title);
			Assert.IsType<ExampleDTO>(result);
		}
	}
}

//// mstest, requires nugetpackages: MSTest.TestFramework + MSTest.TestAdapter
//using Microsoft.VisualStudio.TestTools.UnitTesting;
//using Moq;
//using myshared.Models;
//using myapi.Repositories;
//using myapi.Services;
//using myshared.DTOs;
//using AutoMapper;

//namespace myapi.Tests
//{
//	[TestClass]
//	public class ExampleModelServiceTest
//	{
//		[TestMethod]
//		public async Task GetModelAsync_ValidId_ReturnsDto()
//		{
//			// Arrange
//			var modelId = "1";
//			var expectedModel = new ExampleModel
//			{
//				Id = modelId,
//				Title = "test",
//				Description = "test",
//				WebUrl = "test",
//				ExampleNavigationProperty = null
//			};

//			var mockRepository = new Mock<IExampleModelRepository>();
//			mockRepository
//				.Setup(repo => repo.GetByIdAsync(It.Is<string>(id => id == modelId)))
//				.ReturnsAsync(expectedModel);

//			var mockLogger = new Mock<ILogger<ExampleModelService>>();
//			//var mockAutomapper = new Mock<IMapper>();

//			var service = new ExampleModelService(mockLogger.Object, mockRepository.Object);

//			// Act
//			var result = await service.GetByIdAsync(modelId);

//			// Assert
//			Assert.IsNotNull(result, "Result should not be null");
//			Assert.AreEqual(expectedModel.Id, result.Id, "Ids should match");
//			Assert.AreEqual(expectedModel.Title, result.Title, "Titles should match");
//			Assert.IsInstanceOfType(result, typeof(ExampleDTO));
//		}
//	}
//}
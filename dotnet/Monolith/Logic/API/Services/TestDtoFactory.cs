using Monolith.Logic.API.DTOs;

namespace Monolith.Logic.API.Services
{
	public class TestDtoFactory
	{
		public async Task<TestDto> GetStuff(TestDto testDto)
		{
			await Task.Delay(1000);

			var newDto = new TestDto()
			{
				MyInt = testDto.MyInt,
				MyString = testDto.MyString,
				StringList = testDto.StringList,
				list1 = testDto.list1,
				list2 = testDto.list2,
				Counter = testDto.Counter,
				Title = testDto.Title,
				elementRef = testDto.elementRef,
				elementStyles = testDto.elementStyles
			};

			newDto.MyInt++;
			var x = int.Parse(newDto.MyString);
			x++;
			newDto.MyString = x.ToString();
			newDto.StringList.Remove(testDto.clickedString);

			return newDto;
		}
		public async Task<TestDto> GetInitialStuff()
		{
			await Task.Delay(4000);

			var testDto = new TestDto() { MyInt = 1337, MyString = "69", StringList = new List<string>(), list1 = new List<string>(), list2 = new List<string>() };

			for (int i = 0; i < 50; i++)
			{
				testDto.StringList.Add(i.ToString());
			}

			for (int i = 0; i < 20; i++)
			{
				testDto.list1.Add(i.ToString());
				testDto.list2.Add(i.ToString());
			}

			return testDto;
		}
	}
}

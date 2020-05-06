using System;

namespace RepositoryPattern
{
	class Program
	{
		static void Main(string[] args)
		{
			var userApplicationService = new UserApplicationService(new UserRepository());

			var targetName = "testName";
			userApplicationService.Register(targetName);

			var registeredUser = userApplicationService.Get(targetName);

			Console.WriteLine(registeredUser.Name.Value);
		}
	}
}

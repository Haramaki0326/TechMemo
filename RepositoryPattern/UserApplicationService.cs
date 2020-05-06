using System;
using System.Collections.Generic;
using System.Text;

namespace RepositoryPattern
{
	public class UserApplicationService
	{
		private readonly IUserRepoository userRepoository;
		private readonly UserService userService;

		public UserApplicationService(IUserRepoository userRepoository)
		{
			this.userRepoository = userRepoository;
		}

		public UserApplicationService(IUserRepoository userRepoository, UserService userService)
		{
			this.userRepoository = userRepoository;
			this.userService = userService;
		}

		public void Register(string name)
		{
			var user = new User(
				new UserName(name)
			);

			//if (userService.Exists(user))
			//{
			//	throw new CanNotRegisterUserException(user, "ユーザは既に存在しています。");
			//}

			userRepoository.Save(user);
		}

		public User Get(string userName)
		{
			var targetName = new UserName(userName);
			var user = userRepoository.FindByName(targetName);

			return user;
		}
	}
}

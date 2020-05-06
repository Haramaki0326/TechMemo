using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace RepositoryPattern
{
	public class UserRepository : IUserRepoository
	{
		//private string connectionString = ConfigurationManager.ConnectionStrings["sqlsvr"].ConnectionString;
		private string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Integrated Security=true";

		public void Delete(User user)
		{
			throw new NotImplementedException();
		}

		public User Find(UserId userId)
		{
			throw new NotImplementedException();
		}

		public User FindByName(UserName userName)
		{
			using (var connection = new SqlConnection(connectionString))
			using (var command = connection.CreateCommand())
			{
				connection.Open();
				command.CommandText = @"
	SELECT
		 id
		,name
	FROM
		DDD.dbo.users
	WHERE
		name = @name
";
				command.Parameters.Add(new SqlParameter("@name", userName.Value));
				using (var reader = command.ExecuteReader())
				{
					if (reader.Read())
					{
						var id = reader?["id"] as string;
						var name = reader?["name"] as string;

						return new User(
							new UserId(id),
							new UserName(name)
						);
					}
					else
					{
						return null;
					}
				}
			}
		}
		public List<User> FindAll()
		{
			throw new NotImplementedException();
		}

		public void Save(User user)
		{
			//.NET Coreの場合、SqlConnectionクラスはNuGetからインストールする必要がある。
			using (var connection = new SqlConnection(connectionString))
			using (var command = connection.CreateCommand())
			{
				connection.Open();
				command.CommandText = @"
	MERGE INTO DDD.dbo.users
		USING(
			SELECT
				 @id AS id
				,@name AS name
		) AS data
		ON users.id = data.id
		WHEN MATCHED THEN
			UPDATE SET name = data.name
		WHEN NOT MATCHED THEN
			INSERT (id, name)
			VALUES (data.id, data.name);
";
				command.Parameters.Add(new SqlParameter("@id", user.Id.Value));
				command.Parameters.Add(new SqlParameter("@name", user.Name.Value));
				command.ExecuteNonQuery();
			}
		}
	}
}

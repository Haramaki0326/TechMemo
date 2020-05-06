using System;
using System.Collections.Generic;
using System.Text;

namespace RepositoryPattern
{
    public interface IUserRepoository
    {
        void Save(User user);
        void Delete(User user);
        User Find(UserId userId);
        User FindByName(UserName userName);
        List<User> FindAll();
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace RepositoryPattern
{
    public class User
    {
        public UserId Id { get; }
        public UserName Name { get; private set; }

        public User(UserName name)
        {
            if (name == null) throw new ArgumentNullException(nameof(name));

            Id = new UserId(Guid.NewGuid().ToString());
            Name = name;
        }

        public User(UserId id, UserName name)
        {
            if (id == null) throw new ArgumentNullException(nameof(id));
            if (name == null) throw new ArgumentNullException(nameof(name));

            Id = id;
            Name = name;
        }
    }
}

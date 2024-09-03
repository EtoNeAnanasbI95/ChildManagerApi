package service

type UsersService struct{}

func NewUsersService() *UsersService {
	return &UsersService{}
}

func (us *UsersService) Create() error {
    return nil
}

func (us *UsersService) Delete() error {
    return nil
}

func (us *UsersService) Update() error {
    return nil
}

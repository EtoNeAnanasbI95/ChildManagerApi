package service

type Users interface {
    Create() error
    Update() error
    Delete() error
}

type Service struct {
    Users
}

func NewService() *Service {
    return &Service{
        Users: NewUsersService(),
    }
}

package entity

type OrderRepositoryInterface interface {
	Save(order *Order) error
	GetTotal() (int64, error)
	ListOrders() ([]Order, error)
}

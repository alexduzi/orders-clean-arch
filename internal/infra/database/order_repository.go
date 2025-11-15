package database

import (
	"context"
	"database/sql"

	queries "github.com/alexduzi/orderscleanarch/internal/db"
	"github.com/alexduzi/orderscleanarch/internal/entity"
)

type OrderRepository struct {
	Query *queries.Queries
}

func NewOrderRepository(db *sql.DB) *OrderRepository {
	return &OrderRepository{
		Query: queries.New(db),
	}
}

func (r *OrderRepository) Save(order *entity.Order) error {
	err := r.Query.CreateOrder(context.Background(), queries.CreateOrderParams{
		ID:         order.ID,
		Price:      order.Price,
		Tax:        order.Tax,
		FinalPrice: order.FinalPrice,
	})

	if err != nil {
		return err
	}

	return nil
}

func (r *OrderRepository) GetTotal() (int64, error) {
	total, err := r.Query.GetTotal(context.Background())
	if err != nil {
		return 0, err
	}
	return total, nil
}

func (r *OrderRepository) ListOrders() ([]entity.Order, error) {
	result, err := r.Query.ListOrders(context.Background())
	if err != nil {
		return nil, err
	}

	orders := make([]entity.Order, 0, len(result))

	for _, res := range result {
		orders = append(orders, entity.Order{
			ID:         res.ID,
			Price:      res.Price,
			Tax:        res.Tax,
			FinalPrice: res.FinalPrice,
		})
	}

	return orders, nil
}

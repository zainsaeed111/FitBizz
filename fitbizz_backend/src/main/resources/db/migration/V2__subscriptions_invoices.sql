-- V2__subscriptions_invoices.sql: Subscription & Recurring Invoicing Schema

CREATE TABLE IF NOT EXISTS subscriptions (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    branch_id VARCHAR(36) NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
    member_id VARCHAR(36) NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    plan_id VARCHAR(36) REFERENCES membership_plans(id) ON DELETE SET NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    auto_renew BOOLEAN NOT NULL DEFAULT TRUE,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS invoices (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    branch_id VARCHAR(36) NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
    invoice_number VARCHAR(50) NOT NULL,
    member_id VARCHAR(36) NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    subscription_id VARCHAR(36) REFERENCES subscriptions(id) ON DELETE SET NULL,
    amount DECIMAL(10,2) NOT NULL,
    tax DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(50) NOT NULL DEFAULT 'UNPAID', -- PAID, UNPAID, OVERDUE, CANCELLED
    due_date TIMESTAMP WITH TIME ZONE NOT NULL,
    payment_method VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_invoice_tenant_number UNIQUE (tenant_id, invoice_number)
);

CREATE INDEX IF NOT EXISTS idx_subscriptions_tenant_member ON subscriptions(tenant_id, member_id);
CREATE INDEX IF NOT EXISTS idx_invoices_tenant_status ON invoices(tenant_id, status);

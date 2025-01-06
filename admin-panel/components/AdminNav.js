import Link from 'next/link';

export default function AdminNav() {
  return (
    <nav>
      <Link href="/admin">Dashboard</Link> | 
      <Link href="/admin/add-product">Add Product</Link> | 
      <Link href="/admin/orders">Orders</Link> | 
      <Link href="/admin/users">Users</Link>
    </nav>
  );
}

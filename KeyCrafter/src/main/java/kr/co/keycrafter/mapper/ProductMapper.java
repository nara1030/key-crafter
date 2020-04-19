package kr.co.keycrafter.mapper;

import java.util.List;

import kr.co.keycrafter.domain.ProductVO;

public interface ProductMapper {
	public ProductVO getProduct(int pid);
	
	public void insertProduct(ProductVO product);
	
	public void insertSelectKeyProduct(ProductVO product);
	
	public int updateProduct(ProductVO product);
	
	public int deleteProduct(int pid);
	
	// Not Done
	public List<ProductVO> getProductList();
}

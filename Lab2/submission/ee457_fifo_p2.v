
module ee457_fifo(clk, rst, din, wen, full, dout, ren, empty);
  
  function integer log2;
    input integer n;
    integer i;
    begin
      for (i = 0; 2**i < n; i = i + 1)
      begin
      end
      log2 = i + 1;    
    end
  endfunction

  parameter           WIDTH = 8;
  parameter           DEPTH = 4;
  localparam          ADDR_SIZE = log2(DEPTH);
  
  input               clk;
  input               rst;
  input [WIDTH-1:0]   din;
  input               wen;
  input               ren;
  output [WIDTH-1:0]  dout;
  output              full;
  output              empty;
  
  reg [WIDTH-1:0]     mem_array[0:DEPTH-1];

  reg [ADDR_SIZE-1:0] rptr;
  reg [ADDR_SIZE-1:0] wptr;
  
  // Add other signal declarations here
  reg [ADDR_SIZE-1:0]  counter;
  wire should_read, should_write;
  
  begin
    // always output whatever item the read pointer indicates
    assign dout = mem_array[rptr];

    // Write your code here    
    assign full = counter == DEPTH;
    assign empty = counter == 0;

    assign should_read = ren && !empty;
    assign should_write = (wen && !full) || (wen && full && ren);
    
    always @(posedge clk)
    begin
      if (rst)
      begin
        rptr <= 0;
        wptr <= 0;
        counter <= 0;
      end

      else 
      begin
        if (should_write)
        begin
          mem_array[wptr] <= din;
          wptr <= wptr + 1;
          if (wptr == DEPTH - 1)
            wptr <= 0;
          $display("Wrote %d to %d", din, wptr);
        end

        if (should_read)
        begin
          rptr <= rptr + 1;
          if (rptr == DEPTH - 1)
            rptr <= 0;
          $display("Read %d from %d", mem_array[rptr], rptr);
        end

        if (should_read && should_write)
          counter <= counter;
        else if (should_read && !should_write)
          counter <= counter - 1;
        else if (!should_read && should_write)
          counter <= counter + 1;

        // $display("rptr: %d", rptr);
        // $display("wptr: %d", wptr);
        // $display("counter: %d", counter);

      end

      // $display("Final: %d", mem_array[0]);
      // $display("Final: %d", mem_array[1]);
      // $display("Final: %d", mem_array[2]);
      // $display("Final: %d", mem_array[3]);
      // $display("Final: %d", mem_array[4]);
      // $display("Final: %d", mem_array[5]);
    end

  end
endmodule
  